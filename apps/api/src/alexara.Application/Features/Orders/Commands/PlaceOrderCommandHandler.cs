using FluentResults;
using MediatR;
using alexara.Domain.Entities.Orders;
using alexara.Domain.Interfaces.Repositories;

namespace alexara.Application.Features.Orders.Commands;

public class PlaceOrderCommandHandler : IRequestHandler<PlaceOrderCommand, Result<Guid>>
{
    private readonly IOrderRepository _orderRepository;
    private readonly IProductRepository _productRepository;
    private readonly IUnitOfWork _unitOfWork;

    public PlaceOrderCommandHandler(
        IOrderRepository orderRepository,
        IProductRepository productRepository,
        IUnitOfWork unitOfWork)
    {
        _orderRepository = orderRepository;
        _productRepository = productRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result<Guid>> Handle(PlaceOrderCommand request, CancellationToken cancellationToken)
    {
        var order = Order.Create(request.CustomerId, request.ShippingAddress);

        foreach (var item in request.Items)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId, cancellationToken);
            if (product is null) return Result.Fail($"Producto {item.ProductId} no encontrado.");

            order.AddItem(product.Id, product.Name, item.Quantity, product.Price);
            product.UpdateStock(-item.Quantity);
            await _productRepository.UpdateAsync(product, cancellationToken);
        }

        await _orderRepository.AddAsync(order, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result.Ok(order.Id);
    }
}

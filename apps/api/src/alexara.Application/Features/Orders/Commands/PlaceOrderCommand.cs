using FluentResults;
using MediatR;

namespace alexara.Application.Features.Orders.Commands;

public record PlaceOrderCommand(
    Guid CustomerId,
    string ShippingAddress,
    List<OrderItemDto> Items
) : IRequest<Result<Guid>>;

public record OrderItemDto(Guid ProductId, int Quantity);

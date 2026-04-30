using alexara.Domain.Common;
using alexara.Domain.Enums;
using alexara.Domain.Exceptions;
using alexara.Domain.ValueObjects;

namespace alexara.Domain.Entities.Orders;

public class Order : BaseEntity
{
    public Guid CustomerId { get; private set; }
    public OrderStatus Status { get; private set; }
    public Money Total { get; private set; } = null!;
    public string? ShippingAddress { get; private set; }

    private readonly List<OrderItem> _items = new();
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();

    protected Order() { } // EF Core

    public static Order Create(Guid customerId, string shippingAddress)
    {
        if (customerId == Guid.Empty) throw new DomainException("El cliente es requerido.");
        if (string.IsNullOrWhiteSpace(shippingAddress)) throw new DomainException("La dirección de envío es requerida.");

        return new Order
        {
            CustomerId = customerId,
            Status = OrderStatus.Pending,
            ShippingAddress = shippingAddress,
            Total = new Money(0)
        };
    }

    public void AddItem(Guid productId, string productName, int quantity, Money unitPrice)
    {
        if (Status != OrderStatus.Pending)
            throw new DomainException("Solo se pueden agregar ítems a órdenes pendientes.");

        var existing = _items.FirstOrDefault(i => i.ProductId == productId);
        if (existing != null)
        {
            existing.IncreaseQuantity(quantity);
        }
        else
        {
            _items.Add(OrderItem.Create(Id, productId, productName, quantity, unitPrice));
        }

        RecalculateTotal();
    }

    public void Confirm()
    {
        if (Status != OrderStatus.Pending)
            throw new DomainException("Solo se pueden confirmar órdenes pendientes.");
        if (!_items.Any())
            throw new DomainException("La orden no tiene ítems.");

        Status = OrderStatus.Confirmed;
        UpdatedAt = DateTime.UtcNow;
    }

    public void Cancel()
    {
        if (Status is OrderStatus.Delivered or OrderStatus.Shipped)
            throw new DomainException("No se puede cancelar una orden en ese estado.");

        Status = OrderStatus.Cancelled;
        UpdatedAt = DateTime.UtcNow;
    }

    private void RecalculateTotal()
    {
        var total = _items.Aggregate(new Money(0), (acc, item) => acc.Add(item.Subtotal));
        Total = total;
    }
}

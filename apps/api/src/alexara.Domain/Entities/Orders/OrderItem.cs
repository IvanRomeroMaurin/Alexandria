using alexara.Domain.Common;
using alexara.Domain.Exceptions;
using alexara.Domain.ValueObjects;

namespace alexara.Domain.Entities.Orders;

public class OrderItem : BaseEntity
{
    public Guid OrderId { get; private set; }
    public Guid ProductId { get; private set; }
    public string ProductName { get; private set; } = string.Empty;
    public int Quantity { get; private set; }
    public Money UnitPrice { get; private set; } = null!;
    public Money Subtotal => UnitPrice.Multiply(Quantity);

    protected OrderItem() { }

    public static OrderItem Create(Guid orderId, Guid productId, string productName, int quantity, Money unitPrice)
    {
        if (quantity <= 0) throw new DomainException("La cantidad debe ser mayor a cero.");

        return new OrderItem
        {
            OrderId = orderId,
            ProductId = productId,
            ProductName = productName,
            Quantity = quantity,
            UnitPrice = unitPrice
        };
    }

    internal void IncreaseQuantity(int qty)
    {
        if (qty <= 0) throw new DomainException("La cantidad debe ser mayor a cero.");
        Quantity += qty;
    }
}

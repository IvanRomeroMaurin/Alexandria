using alexara.Domain.Enums;

namespace alexara.Application.Features.Orders.DTOs;

public record OrderDto(
    Guid Id,
    Guid CustomerId,
    OrderStatus Status,
    decimal Total,
    string Currency,
    string? ShippingAddress,
    DateTime CreatedAt,
    List<OrderItemDto> Items
);

public record OrderItemDto(
    Guid ProductId,
    string ProductName,
    int Quantity,
    decimal UnitPrice,
    decimal Subtotal
);

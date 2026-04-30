using alexara.Domain.Common;
using alexara.Domain.Exceptions;
using alexara.Domain.ValueObjects;

namespace alexara.Domain.Entities.Products;

public class Product : BaseEntity
{
    public string Name { get; private set; } = string.Empty;
    public string Description { get; private set; } = string.Empty;
    public Money Price { get; private set; } = null!;
    public int Stock { get; private set; }
    public bool IsActive { get; private set; }
    public string? ImageUrl { get; private set; }
    public Guid CategoryId { get; private set; }

    protected Product() { }

    public static Product Create(string name, string description, Money price, int stock, Guid categoryId)
    {
        if (string.IsNullOrWhiteSpace(name)) throw new DomainException("El nombre del producto es requerido.");
        if (stock < 0) throw new DomainException("El stock no puede ser negativo.");

        return new Product
        {
            Name = name,
            Description = description,
            Price = price,
            Stock = stock,
            CategoryId = categoryId,
            IsActive = true
        };
    }

    public void UpdateStock(int quantity)
    {
        if (Stock + quantity < 0) throw new DomainException("Stock insuficiente.");
        Stock += quantity;
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}

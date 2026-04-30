using alexara.Domain.Exceptions;

namespace alexara.Domain.ValueObjects;

public record Money
{
    public decimal Amount { get; }
    public string Currency { get; }

    public Money(decimal amount, string currency = "ARS")
    {
        if (amount < 0) throw new DomainException("El monto no puede ser negativo.");
        if (string.IsNullOrWhiteSpace(currency)) throw new DomainException("La moneda es requerida.");

        Amount = amount;
        Currency = currency.ToUpper();
    }

    public Money Add(Money other)
    {
        if (Currency != other.Currency) throw new DomainException("No se pueden sumar monedas distintas.");
        return new Money(Amount + other.Amount, Currency);
    }

    public Money Multiply(int quantity) => new(Amount * quantity, Currency);

    public override string ToString() => $"{Currency} {Amount:F2}";
}

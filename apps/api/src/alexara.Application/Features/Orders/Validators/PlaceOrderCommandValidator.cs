using FluentValidation;
using alexara.Application.Features.Orders.Commands;

namespace alexara.Application.Features.Orders.Validators;

public class PlaceOrderCommandValidator : AbstractValidator<PlaceOrderCommand>
{
    public PlaceOrderCommandValidator()
    {
        RuleFor(x => x.CustomerId).NotEmpty().WithMessage("El cliente es requerido.");
        RuleFor(x => x.ShippingAddress).NotEmpty().WithMessage("La dirección de envío es requerida.");
        RuleFor(x => x.Items).NotEmpty().WithMessage("La orden debe tener al menos un ítem.");
        RuleForEach(x => x.Items).ChildRules(item =>
        {
            item.RuleFor(i => i.ProductId).NotEmpty();
            item.RuleFor(i => i.Quantity).GreaterThan(0).WithMessage("La cantidad debe ser mayor a cero.");
        });
    }
}

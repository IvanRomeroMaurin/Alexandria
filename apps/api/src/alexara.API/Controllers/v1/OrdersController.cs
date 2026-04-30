using MediatR;
using Microsoft.AspNetCore.Mvc;
using alexara.Application.Features.Orders.Commands;
using alexara.Application.Features.Orders.Queries;

namespace alexara.API.Controllers.v1;

[ApiController]
[Route("api/v1/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IMediator _mediator;

    public OrdersController(IMediator mediator) => _mediator = mediator;

    /// <summary>Crear una nueva orden</summary>
    [HttpPost]
    public async Task<IActionResult> PlaceOrder([FromBody] PlaceOrderCommand command, CancellationToken cancellationToken)
    {
        var result = await _mediator.Send(command, cancellationToken);
        return result.IsSuccess
            ? CreatedAtAction(nameof(GetOrder), new { id = result.Value }, new { id = result.Value })
            : BadRequest(result.Errors);
    }

    /// <summary>Obtener orden por ID</summary>
    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetOrder(Guid id, CancellationToken cancellationToken)
    {
        var result = await _mediator.Send(new GetOrderByIdQuery(id), cancellationToken);
        return result.IsSuccess ? Ok(result.Value) : NotFound(result.Errors);
    }
}

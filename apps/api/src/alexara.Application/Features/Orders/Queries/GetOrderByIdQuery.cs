using FluentResults;
using MediatR;
using alexara.Application.Features.Orders.DTOs;

namespace alexara.Application.Features.Orders.Queries;

public record GetOrderByIdQuery(Guid OrderId) : IRequest<Result<OrderDto>>;

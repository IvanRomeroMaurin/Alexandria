using FluentValidation;
using System.Net;
using System.Text.Json;
using alexara.Application.Common.Exceptions;

namespace alexara.API.Middleware;

public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception: {Message}", ex.Message);
            await HandleExceptionAsync(context, ex);
        }
    }

    private static async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var (statusCode, message) = exception switch
        {
            NotFoundException ex => (HttpStatusCode.NotFound, ex.Message),
            ValidationException ex => (HttpStatusCode.BadRequest, ex.Message),
            ForbiddenAccessException => (HttpStatusCode.Forbidden, "Acceso denegado."),
            _ => (HttpStatusCode.InternalServerError, "Error interno del servidor.")
        };

        context.Response.ContentType = "application/json";
        context.Response.StatusCode = (int)statusCode;

        var response = new { status = (int)statusCode, message };
        await context.Response.WriteAsync(JsonSerializer.Serialize(response));
    }
}

#!/bin/bash

# ============================================================
#  Clean Architecture - Ecommerce ASP.NET
#  Ejecutar desde la carpeta raíz del proyecto
#  Uso: bash setup-clean-architecture.sh [NombreSolution]
# ============================================================

SOLUTION_NAME=${1:-"Ecommerce"}

echo "🚀 Creando solución: $SOLUTION_NAME"
echo "============================================================"

# ------------------------------------------------------------
# 1. SOLUTION
# ------------------------------------------------------------
dotnet new sln -n "$SOLUTION_NAME"

# ------------------------------------------------------------
# 2. PROYECTOS
# ------------------------------------------------------------
echo ""
echo "📦 Creando proyectos..."

dotnet new classlib -n "$SOLUTION_NAME.Domain"          -o "src/$SOLUTION_NAME.Domain"
dotnet new classlib -n "$SOLUTION_NAME.Application"     -o "src/$SOLUTION_NAME.Application"
dotnet new classlib -n "$SOLUTION_NAME.Infrastructure"  -o "src/$SOLUTION_NAME.Infrastructure"
dotnet new webapi   -n "$SOLUTION_NAME.API"             -o "src/$SOLUTION_NAME.API"

# Test projects
dotnet new xunit    -n "$SOLUTION_NAME.Domain.Tests"       -o "tests/$SOLUTION_NAME.Domain.Tests"
dotnet new xunit    -n "$SOLUTION_NAME.Application.Tests"  -o "tests/$SOLUTION_NAME.Application.Tests"
dotnet new xunit    -n "$SOLUTION_NAME.Integration.Tests"  -o "tests/$SOLUTION_NAME.Integration.Tests"

# ------------------------------------------------------------
# 3. AGREGAR A LA SOLUTION
# ------------------------------------------------------------
echo ""
echo "📎 Agregando proyectos a la solution..."

dotnet sln add "src/$SOLUTION_NAME.Domain/$SOLUTION_NAME.Domain.csproj"
dotnet sln add "src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"
dotnet sln add "src/$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj"
dotnet sln add "src/$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj"
dotnet sln add "tests/$SOLUTION_NAME.Domain.Tests/$SOLUTION_NAME.Domain.Tests.csproj"
dotnet sln add "tests/$SOLUTION_NAME.Application.Tests/$SOLUTION_NAME.Application.Tests.csproj"
dotnet sln add "tests/$SOLUTION_NAME.Integration.Tests/$SOLUTION_NAME.Integration.Tests.csproj"

# ------------------------------------------------------------
# 4. REFERENCIAS ENTRE PROYECTOS (respeta la regla de dependencias)
# Domain  ← Application ← Infrastructure
#                       ↑
#                      API
# ------------------------------------------------------------
echo ""
echo "🔗 Configurando referencias entre proyectos..."

# Application depende de Domain
dotnet add "src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj" \
    reference "src/$SOLUTION_NAME.Domain/$SOLUTION_NAME.Domain.csproj"

# Infrastructure depende de Application y Domain
dotnet add "src/$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj" \
    reference "src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"

dotnet add "src/$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj" \
    reference "src/$SOLUTION_NAME.Domain/$SOLUTION_NAME.Domain.csproj"

# API depende de Application e Infrastructure (solo para DI en Program.cs)
dotnet add "src/$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj" \
    reference "src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"

dotnet add "src/$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj" \
    reference "src/$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj"

# Tests
dotnet add "tests/$SOLUTION_NAME.Domain.Tests/$SOLUTION_NAME.Domain.Tests.csproj" \
    reference "src/$SOLUTION_NAME.Domain/$SOLUTION_NAME.Domain.csproj"

dotnet add "tests/$SOLUTION_NAME.Application.Tests/$SOLUTION_NAME.Application.Tests.csproj" \
    reference "src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"

dotnet add "tests/$SOLUTION_NAME.Integration.Tests/$SOLUTION_NAME.Integration.Tests.csproj" \
    reference "src/$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj"

# ------------------------------------------------------------
# 5. NUGET PACKAGES
# ------------------------------------------------------------
echo ""
echo "📥 Instalando paquetes NuGet..."

# Application
APP="src/$SOLUTION_NAME.Application/$SOLUTION_NAME.Application.csproj"
dotnet add "$APP" package MediatR
dotnet add "$APP" package MediatR.Extensions.Microsoft.DependencyInjection
dotnet add "$APP" package FluentValidation
dotnet add "$APP" package FluentValidation.DependencyInjectionExtensions
dotnet add "$APP" package AutoMapper
dotnet add "$APP" package AutoMapper.Extensions.Microsoft.DependencyInjection
dotnet add "$APP" package FluentResults

# Infrastructure
INFRA="src/$SOLUTION_NAME.Infrastructure/$SOLUTION_NAME.Infrastructure.csproj"
dotnet add "$INFRA" package Microsoft.EntityFrameworkCore
dotnet add "$INFRA" package Microsoft.EntityFrameworkCore.Design
dotnet add "$INFRA" package Npgsql.EntityFrameworkCore.PostgreSQL
dotnet add "$INFRA" package Microsoft.AspNetCore.Identity.EntityFrameworkCore
dotnet add "$INFRA" package StackExchange.Redis
dotnet add "$INFRA" package Serilog
dotnet add "$INFRA" package Serilog.Sinks.Console
dotnet add "$INFRA" package Serilog.Sinks.File

# API
API="src/$SOLUTION_NAME.API/$SOLUTION_NAME.API.csproj"
dotnet add "$API" package Swashbuckle.AspNetCore
dotnet add "$API" package Serilog.AspNetCore
dotnet add "$API" package Microsoft.AspNetCore.Authentication.JwtBearer

# Test packages
APPTESTS="tests/$SOLUTION_NAME.Application.Tests/$SOLUTION_NAME.Application.Tests.csproj"
dotnet add "$APPTESTS" package Moq
dotnet add "$APPTESTS" package FluentAssertions

INTTESTS="tests/$SOLUTION_NAME.Integration.Tests/$SOLUTION_NAME.Integration.Tests.csproj"
dotnet add "$INTTESTS" package Microsoft.AspNetCore.Mvc.Testing
dotnet add "$INTTESTS" package FluentAssertions

# ------------------------------------------------------------
# 6. ESTRUCTURA DE CARPETAS - DOMAIN
# ------------------------------------------------------------
echo ""
echo "📁 Creando estructura de carpetas - Domain..."

DOMAIN_SRC="src/$SOLUTION_NAME.Domain"

# Limpiar archivo por defecto
rm -f "$DOMAIN_SRC/Class1.cs"

# Entities
mkdir -p "$DOMAIN_SRC/Entities/Orders"
mkdir -p "$DOMAIN_SRC/Entities/Products"
mkdir -p "$DOMAIN_SRC/Entities/Users"
mkdir -p "$DOMAIN_SRC/Entities/Payments"

# Value Objects
mkdir -p "$DOMAIN_SRC/ValueObjects"

# Enums
mkdir -p "$DOMAIN_SRC/Enums"

# Interfaces (Repositorios)
mkdir -p "$DOMAIN_SRC/Interfaces/Repositories"
mkdir -p "$DOMAIN_SRC/Interfaces/Services"

# Domain Events
mkdir -p "$DOMAIN_SRC/Events"

# Domain Exceptions
mkdir -p "$DOMAIN_SRC/Exceptions"

# Common / Base
mkdir -p "$DOMAIN_SRC/Common"

# ------------------------------------------------------------
# 7. ESTRUCTURA DE CARPETAS - APPLICATION
# ------------------------------------------------------------
echo ""
echo "📁 Creando estructura de carpetas - Application..."

APP_SRC="src/$SOLUTION_NAME.Application"
rm -f "$APP_SRC/Class1.cs"

# Features - CQRS por aggregate
for feature in Orders Products Catalog Cart Users Auth Payments; do
    mkdir -p "$APP_SRC/Features/$feature/Commands"
    mkdir -p "$APP_SRC/Features/$feature/Queries"
    mkdir -p "$APP_SRC/Features/$feature/DTOs"
    mkdir -p "$APP_SRC/Features/$feature/Validators"
    mkdir -p "$APP_SRC/Features/$feature/Mappers"
done

# Common Application
mkdir -p "$APP_SRC/Common/Behaviors"
mkdir -p "$APP_SRC/Common/Exceptions"
mkdir -p "$APP_SRC/Common/Models"
mkdir -p "$APP_SRC/Common/Interfaces"

# External service interfaces (implemented in Infrastructure)
mkdir -p "$APP_SRC/Interfaces/Email"
mkdir -p "$APP_SRC/Interfaces/Payment"
mkdir -p "$APP_SRC/Interfaces/Storage"
mkdir -p "$APP_SRC/Interfaces/Cache"

# DI registration
mkdir -p "$APP_SRC/DependencyInjection"

# ------------------------------------------------------------
# 8. ESTRUCTURA DE CARPETAS - INFRASTRUCTURE
# ------------------------------------------------------------
echo ""
echo "📁 Creando estructura de carpetas - Infrastructure..."

INFRA_SRC="src/$SOLUTION_NAME.Infrastructure"
rm -f "$INFRA_SRC/Class1.cs"

# Persistence
mkdir -p "$INFRA_SRC/Persistence/Context"
mkdir -p "$INFRA_SRC/Persistence/Configurations"
mkdir -p "$INFRA_SRC/Persistence/Repositories"
mkdir -p "$INFRA_SRC/Persistence/Migrations"
mkdir -p "$INFRA_SRC/Persistence/Seeders"

# Identity
mkdir -p "$INFRA_SRC/Identity/Models"
mkdir -p "$INFRA_SRC/Identity/Services"

# External Services implementations
mkdir -p "$INFRA_SRC/Services/Email"
mkdir -p "$INFRA_SRC/Services/Payment"
mkdir -p "$INFRA_SRC/Services/Storage"
mkdir -p "$INFRA_SRC/Services/Cache"

# Logging
mkdir -p "$INFRA_SRC/Logging"

# DI registration
mkdir -p "$INFRA_SRC/DependencyInjection"

# ------------------------------------------------------------
# 9. ESTRUCTURA DE CARPETAS - API
# ------------------------------------------------------------
echo ""
echo "📁 Creando estructura de carpetas - API..."

API_SRC="src/$SOLUTION_NAME.API"

# Controllers por resource
mkdir -p "$API_SRC/Controllers/v1"

# Middlewares
mkdir -p "$API_SRC/Middleware"

# Filters
mkdir -p "$API_SRC/Filters"

# Extensions
mkdir -p "$API_SRC/Extensions"

# Models (Request/Response específicos de la API)
mkdir -p "$API_SRC/Models/Requests"
mkdir -p "$API_SRC/Models/Responses"

# ------------------------------------------------------------
# 10. ARCHIVOS BASE - DOMAIN
# ------------------------------------------------------------
echo ""
echo "📝 Generando archivos base..."

# Base Entity
cat > "$DOMAIN_SRC/Common/BaseEntity.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Domain.Common;

public abstract class BaseEntity
{
    public Guid Id { get; protected set; } = Guid.NewGuid();
    public DateTime CreatedAt { get; protected set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; protected set; }

    private readonly List<IDomainEvent> _domainEvents = new();
    public IReadOnlyCollection<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();

    protected void AddDomainEvent(IDomainEvent domainEvent) => _domainEvents.Add(domainEvent);
    public void ClearDomainEvents() => _domainEvents.Clear();
}
EOF

# IDomainEvent
cat > "$DOMAIN_SRC/Common/IDomainEvent.cs" << 'EOF'
using MediatR;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Common;

public interface IDomainEvent : INotification { }
EOF

# IRepository genérico
cat > "$DOMAIN_SRC/Interfaces/Repositories/IRepository.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Common;
using System.Linq.Expressions;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;

public interface IRepository<T> where T : BaseEntity
{
    Task<T?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<T>> GetAllAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default);
    Task<T> AddAsync(T entity, CancellationToken cancellationToken = default);
    Task UpdateAsync(T entity, CancellationToken cancellationToken = default);
    Task DeleteAsync(T entity, CancellationToken cancellationToken = default);
    Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default);
}
EOF

# IUnitOfWork
cat > "$DOMAIN_SRC/Interfaces/Repositories/IUnitOfWork.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;

public interface IUnitOfWork : IDisposable
{
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    Task BeginTransactionAsync(CancellationToken cancellationToken = default);
    Task CommitTransactionAsync(CancellationToken cancellationToken = default);
    Task RollbackTransactionAsync(CancellationToken cancellationToken = default);
}
EOF

# Enums - OrderStatus
cat > "$DOMAIN_SRC/Enums/OrderStatus.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Domain.Enums;

public enum OrderStatus
{
    Pending = 0,
    Confirmed = 1,
    Processing = 2,
    Shipped = 3,
    Delivered = 4,
    Cancelled = 5,
    Refunded = 6
}
EOF

# Enums - PaymentStatus
cat > "$DOMAIN_SRC/Enums/PaymentStatus.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Domain.Enums;

public enum PaymentStatus
{
    Pending = 0,
    Approved = 1,
    Rejected = 2,
    Refunded = 3
}
EOF

# Domain Exception base
cat > "$DOMAIN_SRC/Exceptions/DomainException.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Domain.Exceptions;

public class DomainException : Exception
{
    public DomainException(string message) : base(message) { }
    public DomainException(string message, Exception innerException) : base(message, innerException) { }
}
EOF

# Value Object - Money
cat > "$DOMAIN_SRC/ValueObjects/Money.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Exceptions;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.ValueObjects;

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
EOF

# Order Entity
cat > "$DOMAIN_SRC/Entities/Orders/Order.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Common;
using SOLUTION_NAME_PLACEHOLDER.Domain.Enums;
using SOLUTION_NAME_PLACEHOLDER.Domain.Exceptions;
using SOLUTION_NAME_PLACEHOLDER.Domain.ValueObjects;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;

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
EOF

# OrderItem
cat > "$DOMAIN_SRC/Entities/Orders/OrderItem.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Common;
using SOLUTION_NAME_PLACEHOLDER.Domain.Exceptions;
using SOLUTION_NAME_PLACEHOLDER.Domain.ValueObjects;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;

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
EOF

# Product Entity
cat > "$DOMAIN_SRC/Entities/Products/Product.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Common;
using SOLUTION_NAME_PLACEHOLDER.Domain.Exceptions;
using SOLUTION_NAME_PLACEHOLDER.Domain.ValueObjects;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Products;

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
EOF

# IOrderRepository
cat > "$DOMAIN_SRC/Interfaces/Repositories/IOrderRepository.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;
using SOLUTION_NAME_PLACEHOLDER.Domain.Enums;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;

public interface IOrderRepository : IRepository<Order>
{
    Task<IReadOnlyList<Order>> GetByCustomerIdAsync(Guid customerId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Order>> GetByStatusAsync(OrderStatus status, CancellationToken cancellationToken = default);
    Task<Order?> GetWithItemsAsync(Guid orderId, CancellationToken cancellationToken = default);
}
EOF

# IProductRepository
cat > "$DOMAIN_SRC/Interfaces/Repositories/IProductRepository.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Products;

namespace SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;

public interface IProductRepository : IRepository<Product>
{
    Task<IReadOnlyList<Product>> GetByCategoryAsync(Guid categoryId, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> SearchAsync(string searchTerm, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<Product>> GetActiveProductsAsync(CancellationToken cancellationToken = default);
}
EOF

# ------------------------------------------------------------
# 11. ARCHIVOS BASE - APPLICATION
# ------------------------------------------------------------

# Pagination model
cat > "$APP_SRC/Common/Models/PagedResult.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Application.Common.Models;

public class PagedResult<T>
{
    public IReadOnlyList<T> Items { get; }
    public int TotalCount { get; }
    public int Page { get; }
    public int PageSize { get; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
    public bool HasNextPage => Page < TotalPages;
    public bool HasPreviousPage => Page > 1;

    public PagedResult(IReadOnlyList<T> items, int totalCount, int page, int pageSize)
    {
        Items = items;
        TotalCount = totalCount;
        Page = page;
        PageSize = pageSize;
    }
}
EOF

# Validation Behavior (MediatR pipeline)
cat > "$APP_SRC/Common/Behaviors/ValidationBehavior.cs" << 'EOF'
using FluentValidation;
using MediatR;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Common.Behaviors;

public class ValidationBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;

    public ValidationBehavior(IEnumerable<IValidator<TRequest>> validators)
        => _validators = validators;

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        if (!_validators.Any()) return await next();

        var context = new ValidationContext<TRequest>(request);
        var validationResults = await Task.WhenAll(_validators.Select(v => v.ValidateAsync(context, cancellationToken)));
        var failures = validationResults.SelectMany(r => r.Errors).Where(f => f != null).ToList();

        if (failures.Any()) throw new ValidationException(failures);

        return await next();
    }
}
EOF

# Application Exception
cat > "$APP_SRC/Common/Exceptions/ApplicationException.cs" << 'EOF'
namespace SOLUTION_NAME_PLACEHOLDER.Application.Common.Exceptions;

public class NotFoundException : Exception
{
    public NotFoundException(string name, object key) : base($"'{name}' ({key}) no encontrado.") { }
}

public class ForbiddenAccessException : Exception
{
    public ForbiddenAccessException() : base("Acceso denegado.") { }
}
EOF

# DI - Application
cat > "$APP_SRC/DependencyInjection/ApplicationServiceRegistration.cs" << 'EOF'
using FluentValidation;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using SOLUTION_NAME_PLACEHOLDER.Application.Common.Behaviors;

namespace SOLUTION_NAME_PLACEHOLDER.Application.DependencyInjection;

public static class ApplicationServiceRegistration
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddAutoMapper(Assembly.GetExecutingAssembly());
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
        });

        return services;
    }
}
EOF

# CQRS - PlaceOrderCommand sample
cat > "$APP_SRC/Features/Orders/Commands/PlaceOrderCommand.cs" << 'EOF'
using FluentResults;
using MediatR;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Commands;

public record PlaceOrderCommand(
    Guid CustomerId,
    string ShippingAddress,
    List<OrderItemDto> Items
) : IRequest<Result<Guid>>;

public record OrderItemDto(Guid ProductId, int Quantity);
EOF

cat > "$APP_SRC/Features/Orders/Commands/PlaceOrderCommandHandler.cs" << 'EOF'
using FluentResults;
using MediatR;
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Commands;

public class PlaceOrderCommandHandler : IRequestHandler<PlaceOrderCommand, Result<Guid>>
{
    private readonly IOrderRepository _orderRepository;
    private readonly IProductRepository _productRepository;
    private readonly IUnitOfWork _unitOfWork;

    public PlaceOrderCommandHandler(
        IOrderRepository orderRepository,
        IProductRepository productRepository,
        IUnitOfWork unitOfWork)
    {
        _orderRepository = orderRepository;
        _productRepository = productRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result<Guid>> Handle(PlaceOrderCommand request, CancellationToken cancellationToken)
    {
        var order = Order.Create(request.CustomerId, request.ShippingAddress);

        foreach (var item in request.Items)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId, cancellationToken);
            if (product is null) return Result.Fail($"Producto {item.ProductId} no encontrado.");

            order.AddItem(product.Id, product.Name, item.Quantity, product.Price);
            product.UpdateStock(-item.Quantity);
            await _productRepository.UpdateAsync(product, cancellationToken);
        }

        await _orderRepository.AddAsync(order, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result.Ok(order.Id);
    }
}
EOF

# Validator
cat > "$APP_SRC/Features/Orders/Validators/PlaceOrderCommandValidator.cs" << 'EOF'
using FluentValidation;
using SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Commands;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Validators;

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
EOF

# GetOrderQuery sample
cat > "$APP_SRC/Features/Orders/Queries/GetOrderByIdQuery.cs" << 'EOF'
using FluentResults;
using MediatR;
using SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.DTOs;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Queries;

public record GetOrderByIdQuery(Guid OrderId) : IRequest<Result<OrderDto>>;
EOF

cat > "$APP_SRC/Features/Orders/DTOs/OrderDto.cs" << 'EOF'
using SOLUTION_NAME_PLACEHOLDER.Domain.Enums;

namespace SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.DTOs;

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
EOF

# ------------------------------------------------------------
# 12. ARCHIVOS BASE - INFRASTRUCTURE
# ------------------------------------------------------------

# DI - Infrastructure
cat > "$INFRA_SRC/DependencyInjection/InfrastructureServiceRegistration.cs" << 'EOF'
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Repositories;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.DependencyInjection;

public static class InfrastructureServiceRegistration
{
    public static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

        // Repositories
        services.AddScoped(typeof(IRepository<>), typeof(BaseRepository<>));
        services.AddScoped<IOrderRepository, OrderRepository>();
        services.AddScoped<IProductRepository, ProductRepository>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        return services;
    }
}
EOF

# DbContext
cat > "$INFRA_SRC/Persistence/Context/ApplicationDbContext.cs" << 'EOF'
using Microsoft.EntityFrameworkCore;
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Products;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Order> Orders => Set<Order>();
    public DbSet<OrderItem> OrderItems => Set<OrderItem>();
    public DbSet<Product> Products => Set<Product>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
    }
}
EOF

# BaseRepository
cat > "$INFRA_SRC/Persistence/Repositories/BaseRepository.cs" << 'EOF'
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using SOLUTION_NAME_PLACEHOLDER.Domain.Common;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Repositories;

public class BaseRepository<T> : IRepository<T> where T : BaseEntity
{
    protected readonly ApplicationDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public BaseRepository(ApplicationDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public virtual async Task<T?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
        => await _dbSet.FindAsync(new object[] { id }, cancellationToken);

    public virtual async Task<IReadOnlyList<T>> GetAllAsync(CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().ToListAsync(cancellationToken);

    public virtual async Task<IReadOnlyList<T>> FindAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().Where(predicate).ToListAsync(cancellationToken);

    public virtual async Task<T> AddAsync(T entity, CancellationToken cancellationToken = default)
    {
        await _dbSet.AddAsync(entity, cancellationToken);
        return entity;
    }

    public virtual Task UpdateAsync(T entity, CancellationToken cancellationToken = default)
    {
        _dbSet.Update(entity);
        return Task.CompletedTask;
    }

    public virtual Task DeleteAsync(T entity, CancellationToken cancellationToken = default)
    {
        _dbSet.Remove(entity);
        return Task.CompletedTask;
    }

    public virtual async Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default)
        => await _dbSet.AnyAsync(predicate, cancellationToken);
}
EOF

# UnitOfWork
cat > "$INFRA_SRC/Persistence/Repositories/UnitOfWork.cs" << 'EOF'
using Microsoft.EntityFrameworkCore.Storage;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Repositories;

public class UnitOfWork : IUnitOfWork
{
    private readonly ApplicationDbContext _context;
    private IDbContextTransaction? _transaction;

    public UnitOfWork(ApplicationDbContext context) => _context = context;

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        => await _context.SaveChangesAsync(cancellationToken);

    public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
        => _transaction = await _context.Database.BeginTransactionAsync(cancellationToken);

    public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
    {
        if (_transaction != null) await _transaction.CommitAsync(cancellationToken);
    }

    public async Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
    {
        if (_transaction != null) await _transaction.RollbackAsync(cancellationToken);
    }

    public void Dispose() => _context.Dispose();
}
EOF

# OrderRepository
cat > "$INFRA_SRC/Persistence/Repositories/OrderRepository.cs" << 'EOF'
using Microsoft.EntityFrameworkCore;
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Orders;
using SOLUTION_NAME_PLACEHOLDER.Domain.Enums;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Repositories;

public class OrderRepository : BaseRepository<Order>, IOrderRepository
{
    public OrderRepository(ApplicationDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Order>> GetByCustomerIdAsync(Guid customerId, CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().Where(o => o.CustomerId == customerId).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Order>> GetByStatusAsync(OrderStatus status, CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().Where(o => o.Status == status).ToListAsync(cancellationToken);

    public async Task<Order?> GetWithItemsAsync(Guid orderId, CancellationToken cancellationToken = default)
        => await _dbSet.Include(o => o.Items).FirstOrDefaultAsync(o => o.Id == orderId, cancellationToken);
}
EOF

# ProductRepository
cat > "$INFRA_SRC/Persistence/Repositories/ProductRepository.cs" << 'EOF'
using Microsoft.EntityFrameworkCore;
using SOLUTION_NAME_PLACEHOLDER.Domain.Entities.Products;
using SOLUTION_NAME_PLACEHOLDER.Domain.Interfaces.Repositories;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Context;

namespace SOLUTION_NAME_PLACEHOLDER.Infrastructure.Persistence.Repositories;

public class ProductRepository : BaseRepository<Product>, IProductRepository
{
    public ProductRepository(ApplicationDbContext context) : base(context) { }

    public async Task<IReadOnlyList<Product>> GetByCategoryAsync(Guid categoryId, CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().Where(p => p.CategoryId == categoryId && p.IsActive).ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Product>> SearchAsync(string searchTerm, CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking()
            .Where(p => p.IsActive && (p.Name.Contains(searchTerm) || p.Description.Contains(searchTerm)))
            .ToListAsync(cancellationToken);

    public async Task<IReadOnlyList<Product>> GetActiveProductsAsync(CancellationToken cancellationToken = default)
        => await _dbSet.AsNoTracking().Where(p => p.IsActive).ToListAsync(cancellationToken);
}
EOF

# ------------------------------------------------------------
# 13. ARCHIVOS BASE - API
# ------------------------------------------------------------

# Global exception middleware
cat > "$API_SRC/Middleware/ExceptionHandlingMiddleware.cs" << 'EOF'
using FluentValidation;
using System.Net;
using System.Text.Json;
using SOLUTION_NAME_PLACEHOLDER.Application.Common.Exceptions;

namespace SOLUTION_NAME_PLACEHOLDER.API.Middleware;

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
EOF

# Orders Controller
cat > "$API_SRC/Controllers/v1/OrdersController.cs" << 'EOF'
using MediatR;
using Microsoft.AspNetCore.Mvc;
using SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Commands;
using SOLUTION_NAME_PLACEHOLDER.Application.Features.Orders.Queries;

namespace SOLUTION_NAME_PLACEHOLDER.API.Controllers.v1;

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
EOF

# Program.cs
cat > "$API_SRC/Program.cs" << 'EOF'
using Serilog;
using SOLUTION_NAME_PLACEHOLDER.API.Middleware;
using SOLUTION_NAME_PLACEHOLDER.Application.DependencyInjection;
using SOLUTION_NAME_PLACEHOLDER.Infrastructure.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);

// Logging
builder.Host.UseSerilog((ctx, lc) => lc
    .ReadFrom.Configuration(ctx.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console());

// Application layers DI
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices(builder.Configuration);

// API
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = "Ecommerce API", Version = "v1" });
});

builder.Services.AddAuthentication().AddJwtBearer();
builder.Services.AddAuthorization();

var app = builder.Build();

// Middleware pipeline
app.UseMiddleware<ExceptionHandlingMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
EOF

# appsettings.json
cat > "$API_SRC/appsettings.json" << 'EOF'
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=ecommerce_db;Username=postgres;Password=postgres"
  },
  "JwtSettings": {
    "SecretKey": "CHANGE_ME_IN_PRODUCTION_32_CHARS_MIN",
    "Issuer": "EcommerceAPI",
    "Audience": "EcommerceClient",
    "ExpirationMinutes": 60
  },
  "Serilog": {
    "MinimumLevel": {
      "Default": "Information",
      "Override": {
        "Microsoft": "Warning",
        "System": "Warning"
      }
    }
  }
}
EOF

# ------------------------------------------------------------
# 14. REEMPLAZAR NAMESPACE PLACEHOLDER
# ------------------------------------------------------------
echo ""
echo "🔧 Ajustando namespaces con el nombre de la solution..."

find "src/" "tests/" -name "*.cs" -type f | while read file; do
    sed -i "s/SOLUTION_NAME_PLACEHOLDER/$SOLUTION_NAME/g" "$file"
done

# ------------------------------------------------------------
# 15. .gitignore
# ------------------------------------------------------------
cat > .gitignore << 'EOF'
# Build
bin/
obj/
*.user

# VS / Rider
.vs/
.idea/
*.suo

# Publish
publish/

# Env
.env
*.env

# Migrations (opcional - algunos los commitean)
# **/Migrations/

# Logs
logs/
*.log
EOF

# ------------------------------------------------------------
# 16. README
# ------------------------------------------------------------
cat > README.md << 'EOF'
# Ecommerce - Clean Architecture (ASP.NET)

## Estructura de la solution

```
src/
├── Domain          # Entidades, Value Objects, Interfaces, Domain Events
├── Application     # Casos de uso CQRS (MediatR), Validaciones, DTOs
├── Infrastructure  # EF Core, Repositorios, Servicios externos
└── API             # Controllers, Middleware, Program.cs

tests/
├── Domain.Tests
├── Application.Tests
└── Integration.Tests
```

## Reglas de dependencia
- **Domain** → sin dependencias externas
- **Application** → solo Domain
- **Infrastructure** → Application + Domain
- **API** → Application + Infrastructure (solo Program.cs para DI)

## Primeros pasos

```bash
# Restaurar paquetes
dotnet restore

# Crear migración inicial
dotnet ef migrations add Initial --project src/SOLUTION.Infrastructure --startup-project src/SOLUTION.API

# Aplicar migración
dotnet ef database update --project src/SOLUTION.Infrastructure --startup-project src/SOLUTION.API

# Ejecutar
dotnet run --project src/SOLUTION.API
```
EOF

# ------------------------------------------------------------
# FINAL
# ------------------------------------------------------------
echo ""
echo "============================================================"
echo "✅ Estructura creada exitosamente."
echo ""
echo "📂 Proyectos generados:"
echo "   src/$SOLUTION_NAME.Domain"
echo "   src/$SOLUTION_NAME.Application"
echo "   src/$SOLUTION_NAME.Infrastructure"
echo "   src/$SOLUTION_NAME.API"
echo "   tests/$SOLUTION_NAME.Domain.Tests"
echo "   tests/$SOLUTION_NAME.Application.Tests"
echo "   tests/$SOLUTION_NAME.Integration.Tests"
echo ""
echo "▶  Próximo paso:"
echo "   cd <tu-carpeta>"
echo "   bash setup-clean-architecture.sh MiEcommerce"
echo "   dotnet restore"
echo "   dotnet build"
echo "============================================================"

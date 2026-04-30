using Microsoft.EntityFrameworkCore;
using alexara.Domain.Entities.Orders;
using alexara.Domain.Enums;
using alexara.Domain.Interfaces.Repositories;
using alexara.Infrastructure.Persistence.Context;

namespace alexara.Infrastructure.Persistence.Repositories;

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

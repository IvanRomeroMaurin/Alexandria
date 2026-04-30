using Microsoft.EntityFrameworkCore;
using alexara.Domain.Entities.Products;
using alexara.Domain.Interfaces.Repositories;
using alexara.Infrastructure.Persistence.Context;

namespace alexara.Infrastructure.Persistence.Repositories;

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

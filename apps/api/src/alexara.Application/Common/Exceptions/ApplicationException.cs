namespace alexara.Application.Common.Exceptions;

public class NotFoundException : Exception
{
    public NotFoundException(string name, object key) : base($"'{name}' ({key}) no encontrado.") { }
}

public class ForbiddenAccessException : Exception
{
    public ForbiddenAccessException() : base("Acceso denegado.") { }
}

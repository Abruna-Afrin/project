class UserNotFoundException(Exception):
    """Raised when a user is not found in the database"""
    pass

class DatabaseException(Exception):
    """Raised when a database operation fails"""
    pass

class ValidationException(Exception):
    """Raised when input validation fails"""
    pass

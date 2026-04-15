# Testing with Pytest


## Creating tests

Roughly follow an "arrange - act - assert" structure by grouping
blocks of code which are one of three parts of the structure.
Separate them by a newline.

```python
# test_user.py
import pytest
from myapp.user import User, UserService

# Simple test function (arrange and act are one here.)
def test_user_creation() -> None:
    user = User(id=1, name="Alice", email="alice@example.com")

    assert user.name == "Alice"
    assert user.is_active is True

# testing errors.
def test_user_validation() -> None:
    with pytest.raises(ValueError, match="Invalid email"):
        User(id=1, name="Alice", email="invalid")

# Test class for grouping
class TestUserService:
    def test_find_user(self) -> None:
        service = UserService()

        user = service.find(1)

        assert user is not None

    def test_create_user(self) -> None:
        service = UserService()

        user = service.create(name="Bob", email="bob@example.com")

        assert user.id > 0
```

### Fixtures for Setup/Teardown

```python
# conftest.py - shared fixtures
import pytest
from typing import Iterator
from myapp.database import Database, Session

@pytest.fixture
def db() -> Iterator[Database]:
    """Provide database instance with cleanup."""
    database = Database("test.db")
    database.create_tables()

    yield database

    database.drop_tables()
    database.close()

@pytest.fixture
def db_session(db: Database) -> Iterator[Session]:
    """Provide database session with rollback."""
    session = db.create_session()

    yield session

    session.rollback()
    session.close()

@pytest.fixture
def sample_user() -> User:
    """Provide test user."""
    return User(id=1, name="Test User", email="test@example.com")

# Using fixtures in tests
def test_user_creation(db_ssession: Session, sample_user: User) -> None:
    db_session.add(sample_user)
    db_session.commit()

    retrieved = db_session.query(User).filter_by(id=1).first()

    assert retrieved.name == "Test User"

# Fixture with parameters
@pytest.fixture(params=["sqlite", "postgresql", "mysql"])
def db_engine(request: pytest.FixtureRequest) -> str:
    return request.param

def test_connection(db_engine: str) -> None:
    # Test runs 3 times with different engines
    assert create_connection(db_engine)

# Autouse fixture (runs automatically)
@pytest.fixture(autouse=True)
def reset_state() -> Iterator[None]:
    """Reset global state before each test."""
    clear_caches()

    yield

    cleanup_temp_files()
```

## Parametrize for Multiple Cases

```python
import pytest

# Parametrize test function
@pytest.mark.parametrize(
    "input,expected",
    [
        (2, 4),
        (3, 9),
        (4, 16),
        (-2, 4),
    ]
)
def test_square(input: int, expected: int) -> None:
    assert square(input) == expected

# Multiple parameters
@pytest.mark.parametrize("base", [2, 10])
@pytest.mark.parametrize("exponent", [0, 1, 2])
def test_power(base: int, exponent: int) -> None:
    result = base ** exponent
    assert result >= 0

# Parametrize with IDs
@pytest.mark.parametrize(
    "email,valid",
    [
        ("user@example.com", True),
        ("invalid", False),
        ("@example.com", False),
        ("user@", False),
    ],
    ids=["valid", "no_at", "no_user", "no_domain"]
)
def test_email_validation(email: str, valid: bool) -> None:
    assert is_valid_email(email) == valid

# Parametrize with fixtures
@pytest.fixture
def user_factory():
    def _make_user(name: str, active: bool = True) -> User:
        return User(name=name, active=active)
    return _make_user

@pytest.mark.parametrize("name", ["Alice", "Bob", "Charlie"])
def test_user_names(user_factory, name: str) -> None:
    user = user_factory(name)
    assert user.name == name
```

## Mocking and Patching

```python
from unittest.mock import Mock, MagicMock, patch, AsyncMock, call
import pytest

# Mock object
def test_api_call_with_mock() -> None:
    mock_client = Mock()
    mock_client.get.return_value = {"status": "ok"}

    service = ApiService(mock_client)
    result = service.fetch_data()

    mock_client.get.assert_called_once_with("/api/data")
    assert result["status"] == "ok"

# Patch function/method
def test_database_call() -> None:
    with patch("myapp.database.connect") as mock_connect:
        mock_connect.return_value = Mock()

        db = Database()
        db.connect()

        mock_connect.assert_called_once()

# Patch as decorator
@patch("myapp.user.send_email")
def test_user_registration(mock_send_email: Mock) -> None:
    service = UserService()
    service.register("user@example.com")

    mock_send_email.assert_called_with(
        to="user@example.com",
        subject="Welcome"
    )

# Multiple patches
@patch("myapp.api.requests.get")
@patch("myapp.api.cache.get")
def test_cached_api(mock_cache: Mock, mock_requests: Mock) -> None:
    mock_cache.return_value = None
    mock_requests.return_value.json.return_value = {"data": "value"}

    result = fetch_with_cache("key")

    mock_cache.assert_called_once_with("key")
    mock_requests.assert_called_once()

# Mock side effects
def test_retry_logic() -> None:
    mock_api = Mock()
    mock_api.call.side_effect = [
        ConnectionError("Failed"),
        ConnectionError("Failed"),
        {"status": "ok"}
    ]

    result = retry_api_call(mock_api)
    assert result["status"] == "ok"
    assert mock_api.call.call_count == 3

# Async mock
@pytest.mark.asyncio
async def test_async_function() -> None:
    mock_db = AsyncMock()
    mock_db.fetch_user.return_value = User(id=1, name="Alice")

    service = AsyncUserService(mock_db)
    user = await service.get_user(1)

    mock_db.fetch_user.assert_awaited_once_with(1)
    assert user.name == "Alice"
```


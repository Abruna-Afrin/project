"""
Global pytest fixtures and configurations.
"""
import pytest
from pathlib import Path

@pytest.fixture(scope="session")
def test_data_dir() -> Path:
    """Return the path to the test data directory."""
    return Path(__file__).parent / "data"

@pytest.fixture(scope="session")
def config():
    """Global test configuration."""
    return {
        "environment": "test",
        "log_level": "DEBUG"
    }

def pytest_configure(config):
    """Configure pytest with custom markers."""
    config.addinivalue_line(
        "markers", "integration: mark test as an integration test"
    )
    config.addinivalue_line(
        "markers", "unit: mark test as a unit test"
    )

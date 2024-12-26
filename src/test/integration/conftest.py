"""
Database test fixtures using configuration from config.json.
"""
import pytest
import mysql.connector
from typing import Generator
import json
from pathlib import Path

def load_config(env: str = "test") -> dict:
    """Load database configuration from config.json."""
    config_path = Path(__file__).parent / "config.json"
    with open(config_path) as f:
        config = json.load(f)
    return config["mysql"][env]

@pytest.fixture(scope="session")
def db_config():
    """Database configuration for tests."""
    return load_config("test")

@pytest.fixture(scope="session")
def db_connection(db_config) -> Generator[mysql.connector.MySQLConnection, None, None]:
    """Create a database connection for testing."""
    connection = mysql.connector.connect(**db_config)
    yield connection
    connection.close()

@pytest.fixture(scope="function")
def db_cursor(db_connection) -> Generator[mysql.connector.MySQLConnection.cursor, None, None]:
    """Create a database cursor and handle transaction rollback."""
    cursor = db_connection.cursor(dictionary=True)
    yield cursor
    db_connection.rollback()  # Roll back any changes made during the test
    cursor.close()

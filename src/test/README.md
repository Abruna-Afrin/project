# Test Suite

This directory contains the test suite for the project. The tests are organized following pytest best practices.

## Structure

```
test/
├── conftest.py           # Global fixtures and configurations
├── pytest.ini           # Pytest configuration
├── requirements-test.txt # Test dependencies
├── unit/               # Unit tests
├── integration/        # Integration tests
└── utils/             # Test utilities and helpers
```

## Setup

1. Install test dependencies:
```bash
pip install -r requirements-test.txt
```

2. Run tests:
```bash
pytest
```

## Test Categories

- **Unit Tests**: Fast tests that check individual components in isolation
- **Integration Tests**: Tests that check multiple components working together

## Markers

- `@pytest.mark.unit`: Unit tests
- `@pytest.mark.integration`: Integration tests
- `@pytest.mark.slow`: Slow running tests

## Coverage

Test coverage reports are generated automatically when running tests. View the coverage report with:
```bash
pytest --cov-report=html
```

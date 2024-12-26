"""
Integration tests for user profile stored procedures.
"""
import pytest
from mysql.connector import MySQLConnection, Error
from typing import Dict, Any

@pytest.fixture
def sample_user_profile() -> Dict[str, Any]:
    """Sample user profile data for testing."""
    return {
        'user_id': 1,
        'nationality': 'American',
        'religion': 'Christianity',
        'height': '175cm',
        'marital_status': 'Single',
        'bio': 'A software engineer who loves traveling'
    }

@pytest.mark.integration
def test_create_user_profile_success(db_connection: MySQLConnection, 
                                   db_cursor, 
                                   sample_user_profile: Dict[str, Any]):
    """Test successful creation of user profile."""
    try:
        # Call the stored procedure
        db_cursor.callproc('CreateUserProfile', [
            sample_user_profile['user_id'],
            sample_user_profile['nationality'],
            sample_user_profile['religion'],
            sample_user_profile['height'],
            sample_user_profile['marital_status'],
            sample_user_profile['bio']
        ])
        
        # Commit the transaction
        db_connection.commit()
        
        # Verify the profile was created
        db_cursor.execute("""
            SELECT * FROM user_profiles 
            WHERE user_id = %s
        """, (sample_user_profile['user_id'],))
        
        result = db_cursor.fetchone()
        
        assert result is not None
        assert result['nationality'] == sample_user_profile['nationality']
        assert result['religion'] == sample_user_profile['religion']
        assert result['height'] == sample_user_profile['height']
        assert result['marital_status'] == sample_user_profile['marital_status']
        assert result['bio'] == sample_user_profile['bio']
        
    except Error as err:
        pytest.fail(f"Failed to create user profile: {err}")

@pytest.mark.integration
def test_create_user_profile_duplicate(db_cursor, sample_user_profile: Dict[str, Any]):
    """Test creating duplicate user profile."""
    # First creation should succeed
    db_cursor.callproc('CreateUserProfile', [
        sample_user_profile['user_id'],
        sample_user_profile['nationality'],
        sample_user_profile['religion'],
        sample_user_profile['height'],
        sample_user_profile['marital_status'],
        sample_user_profile['bio']
    ])
    
    # Second creation should raise an error
    with pytest.raises(Error) as exc_info:
        db_cursor.callproc('CreateUserProfile', [
            sample_user_profile['user_id'],
            sample_user_profile['nationality'],
            sample_user_profile['religion'],
            sample_user_profile['height'],
            sample_user_profile['marital_status'],
            sample_user_profile['bio']
        ])
    
    assert "Duplicate entry" in str(exc_info.value)

@pytest.mark.integration
def test_create_user_profile_invalid_user(db_cursor):
    """Test creating profile for non-existent user."""
    invalid_user_id = 99999
    
    with pytest.raises(Error) as exc_info:
        db_cursor.callproc('CreateUserProfile', [
            invalid_user_id,
            'American',
            'Christianity',
            '175cm',
            'Single',
            'Bio'
        ])
    
    assert "foreign key constraint" in str(exc_info.value).lower()

import mysql.connector
import yaml
import logging
from logstash_formatter import LogstashFormatterV1
from elasticsearch import Elasticsearch

class UserRepository:

    def __init__(self):
        
        # Load configuration
        with open('config.yaml', 'r') as file:
            self.config = yaml.safe_load(file)

        # Set up database connection
        self.db_config = self.config['database']
        self.connection = mysql.connector.connect(
            host=self.db_config['host'],
            user=self.db_config['user'],
            password=self.db_config['password'],
            database=self.db_config['database']
        )

        # Set up Elasticsearch logging
        self.es_config = self.config['logging']
        self.es = Elasticsearch([self.es_config['elasticsearch_host']])
        self.logger = logging.getLogger('user_repository')
        self.logger.setLevel(logging.INFO)
        es_handler = logging.StreamHandler()
        es_handler.setFormatter(LogstashFormatterV1())
        self.logger.addHandler(es_handler)

    def create_user_profile(self, user_id, nationality, religion, height, marital_status, bio):
        try:
            cursor = self.connection.cursor()
            cursor.callproc('CreateUserProfile', [user_id, nationality, religion, height, marital_status, bio])
            self.connection.commit()
            self.logger.info('User profile created', extra={'user_id': user_id})
        except mysql.connector.Error as err:
            self.logger.error('Error creating user profile', extra={'error': str(err)})
        finally:
            cursor.close()

# Example usage
if __name__ == "__main__":
    repo = UserRepository()
    repo.create_user_profile(1, 'American', 'Christian', '6ft', 'Single', 'Bio example')

# api => service => repository

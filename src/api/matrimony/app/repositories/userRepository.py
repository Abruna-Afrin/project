import mysql.connector
import json

class UserRepository:
    def __init__(self, config_file='config.json'):
        with open(config_file, 'r') as file:
            config = json.load(file)
        
        db_config = config['database']
        
        self.connection = mysql.connector.connect(
            host=db_config['host'],
            user=db_config['user'],
            password=db_config['password'],
            database=db_config['database']
        )
        self.cursor = self.connection.cursor()

    def create_user(self, first_name, last_name, dob, gender, email, phone, address):
        try:
            proc_name = 'CreateUser'
            params = (first_name, last_name, dob, gender, email, phone, address, 0)
            self.cursor.callproc(proc_name, params)
            
            # Fetch the OUT parameter
            for result in self.cursor.stored_results():
                user_id = result.fetchone()[0]
            
            self.connection.commit()
            return user_id
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            return None
        finally:
            self.cursor.close()
            self.connection.close()

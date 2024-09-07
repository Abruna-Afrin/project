class UserService:
    def __init__(self, user_repository):
        self.user_repository = user_repository

    def create_user(self, first_name, last_name, dob, gender, email, phone, address):
        return self.user_repository.create_user(first_name, last_name, dob, gender, email, phone, address)

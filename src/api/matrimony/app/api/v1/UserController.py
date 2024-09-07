from user_service import UserService
from user_repository import UserRepository

user_blueprint = Blueprint('user', __name__)

# Initialize the repository and service with config file
user_repository = UserRepository(config_file='config.json')
user_service = UserService(user_repository)

@user_blueprint.route('/create', methods=['POST'])
def create_user():
    data = request.get_json()
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    dob = data.get('dob')
    gender = data.get('gender')
    email = data.get('email')
    phone = data.get('phone')
    address = data.get('address')
    
    user_id = user_service.create_user(first_name, last_name, dob, gender, email, phone, address)
    
    if user_id:
        return jsonify({"user_id": user_id}), 201
    else:
        return jsonify({"error": "User creation failed"}), 500


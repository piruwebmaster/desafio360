import jwt from 'jsonwebtoken';

const generateToken = (payload: object) => {
  const secretKey = process.env.JWT_SECRET ?? "claveSuperSecreta"; // Replace with your own secret key
  const JWT_EXPIRATION_IN_HOURS = process.env.JWT_EXPIRATION_IN_HOURS ?? 24
  const expiration: string = `${JWT_EXPIRATION_IN_HOURS}h`;
  const options = {
    expiresIn: expiration, // Token expiration time
  };

  const token = jwt.sign(payload, secretKey, options);
  const response = {
    "access_token": token,
    "token_type": "bearer",
    "expires_in": + JWT_EXPIRATION_IN_HOURS * 60 * 60
  }
  return response;
};

export { generateToken }
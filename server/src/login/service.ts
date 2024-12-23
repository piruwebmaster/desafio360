import {findById} from '@users/service'
import { LoginDto } from './types';
import { loginByEmail } from './repository';
import { compare } from '@utils/security/hasher';
import { generateToken } from '@utils/security/jwt';


export const login = async (dto: LoginDto)=>{
    const loginInfo = await loginByEmail(dto.email)    
    const success = await compare({ content: dto.password, encrypted: loginInfo.password})
    if(!success) return null;
    const user = await findById(loginInfo.id);
    const token = generateToken(user);
    return token;
}
    
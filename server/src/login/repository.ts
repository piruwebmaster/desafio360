import { db } from '@utils/persistence/database';


import { Login } from './types';

export const  loginByEmail = async (email: string) =>{
    const { query } = db();
    const r = await query<Login>({
      query: "SELECT id, email, password from SALES.VW_LOGIN where email = :email",
      replacement: { email }
    })
    return r[0]
}
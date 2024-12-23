import { db } from '../utils/persistence/database';
import { Pagination } from '../utils/schemas/pagination';


import { Entity, CreateEntity, UpdateEntity } from './types';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Entity>({
      query: "SELECT id, email, phone_number, date_of_birth, state_id, role_id from sales.VW_USERS ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const results = await query<Entity>({ query: "SELECT id, email, phone_number, date_of_birth, state_id, role_id from sales.VW_USERS where id = :id",  replacement: { id} } )
    return results[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.life_cicle_user :id, 'ELIMINADO'", replacement:  {id} });
  
}

export const insertEntity = async (entity: CreateEntity) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_user :email, :phone_number, :date_of_birth, :password, :role_id, 4", replacement:  entity });
  return id
  
}

export const updateEntity = async (entity: UpdateEntity) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_user :id, :email, :phone_number, :date_of_birth", replacement: entity   });
  
}
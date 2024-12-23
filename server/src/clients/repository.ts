import { db } from '../utils/persistence/database';
import { Pagination } from '../utils/schemas/pagination';


import { Entity, CreateEntity, UpdateEntity } from './types';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Entity>({
      query: "SELECT id, legal_name, trade_name, shipping_address, phone_number, email, user_id, state_id from SALES.VW_CLIENTS ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const results = await query<Entity>({ query: "SELECT id, legal_name, trade_name, shipping_address, phone_number, email, user_id, state_id from SALES.VW_CLIENTS where id = :id",  replacement: { id} } )
    return results[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.life_cicle_shipping_information :id, 'ELIMINADO'", replacement:  {id} });
  
}

export const insertEntity = async (entity: CreateEntity) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_shipping_information :legal_name, :trade_name, :shipping_address, :phone_number, :email, :user_id, 4", replacement:  entity });
  return id
  
}

export const updateEntity = async (entity: UpdateEntity) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_shipping_information :id, :legal_name, :trade_name, :shipping_address, :phone_number, :email", replacement: entity   });
  
}
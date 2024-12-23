import { db } from '../utils/persistence/database';
import { Pagination } from '../utils/schemas/pagination';


import { Entity, CreateEntity, UpdateEntity } from './types';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Entity>({
      query: "SELECT id, client_id, estimated_delivery_date, delivery_date, order_state_id from SALES.VW_ORDERS ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const results = await query<Entity>({ query: "SELECT id, client_id, estimated_delivery_date, delivery_date, order_state_id from SALES.VW_ORDERS where id = :id",  replacement: { id} } )
    return results[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec sales.life_cicle_orders :id, 'CANCELLED'", replacement:  {id} });
  
}

export const insertEntity = async (entity: CreateEntity, userId: number) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_order :client_id, :estimated_delivery_date, :delivery_date, :order_state_id, :userId", replacement:  {...entity, estimated_delivery_date: entity.estimated_delivery_date?.toJSON(), delivery_date:  entity.delivery_date?.toJSON() ?? null, userId} });
  return id
  
}

export const updateEntity = async (entity: UpdateEntity, userId: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_order :id, :estimated_delivery_date, :delivery_date, :userId ", replacement: {...entity, estimated_delivery_date: entity.estimated_delivery_date?.toJSON(), delivery_date:  entity.delivery_date?.toJSON() ?? null, userId}   });
  
}
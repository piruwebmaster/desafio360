import { db } from '@utils/persistence/database';
import { Pagination } from '@utils/schemas/pagination';


import { Entity, CreateEntity, UpdateEntity } from './types';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Entity>({
      query: "SELECT id, order_id, quantity, tax_rate, sell_price, state_id, product_id FROM sales.VW_ORDER_DETAILS ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const results = await query<Entity>({ query: "SELECT id, order_id, quantity, tax_rate, sell_price, state_id, product_id FROM sales.VW_ORDER_DETAILS where id = :id",  replacement: { id} } )
    return results[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec life_cicle_update_orders_details :id, 'CANCELLED'", replacement:  {id} });
  
}

export const insertEntity = async (entity: CreateEntity) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_order_details :order_id, :quantity, :tax_rate, :sell_price, :product_id, 9", replacement:  entity });
  return id
  
}

export const updateEntity = async (entity: UpdateEntity) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_order_details :id, :quantity, :tax_rate, :sell_price ", replacement: entity });
  
}
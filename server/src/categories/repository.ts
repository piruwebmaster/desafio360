import { db } from '../utils/persistence/database';
import { Pagination } from '../utils/schemas/pagination';


import { Category, CreateCategory, UpdateCategory } from './types';

export const  getEntities = async ({ page, limit }: Pagination) =>{
    const { query } = db();
    const r = await query<Category>({
      query: "SELECT id, name, state_id from sales.VW_CATEGORIES ORDER by id offset ((:page - 1) * :limit) rows fetch next :limit rows only",
      replacement: {
        page: page,
        limit: limit
      }
    })
    return r
}

export const getEntityBydId = async (id: number) =>{
    const { query } = db();
    const results = await query<Category>({ query: "SELECT id, name, state_id from sales.VW_CATEGORIES where id = :id",  replacement: { id} } )
    return results[0]
}

export const disableEntityById = async (id: number) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.life_cicle_category :id, 'ELIMINADO'", replacement:  {id} });
  
}

export const insertEntity = async (product: CreateCategory) =>{
  const { insertProcedure } = db();
  const id  = await insertProcedure({query: "exec SALES.insert_category :name, 4", replacement:  product });
  return id
  
}

export const updateEntity = async (product: UpdateCategory) =>{
  const { procedure } = db();
  return await procedure({query: "exec SALES.update_category :id, :name ", replacement: product   });
  
}
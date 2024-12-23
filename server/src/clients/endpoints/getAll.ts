import express from 'express'
import { list } from '../service';
import { queryValidatorMiddleware } from '@middlewares/queryValidatorMiddleware';
import z from 'zod'
import { paginationSchema } from '@utils/schemas/pagination';

const router = express.Router();



router.get('/', queryValidatorMiddleware(paginationSchema) , async (req, res)=>{
    /* #swagger.parameters['page'] = {
        in: 'query',                            
        description: 'Page number, default value 1',
        required: false,
        type: 'number'
    } */
    const data = await list(req.query as  z.infer<typeof paginationSchema>)
    res.json(data)
})

export default router;
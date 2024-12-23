import express from 'express'
import { add } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createSchema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createSchema), async (req, res)=>{
    console.log(req.body)
    const body = {...req.body, delivery_date: req.body.delivery_date ?? null  }
    
    const data = await add(body, req.user?.id??0)
    res.json(data)
})

export default router;
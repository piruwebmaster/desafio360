import express from 'express'
import { add } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createSchema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createSchema), async (req, res)=>{
    console.log(req.body)
    
    const data = await add({...req.body})
    res.json(data)
})

export default router;
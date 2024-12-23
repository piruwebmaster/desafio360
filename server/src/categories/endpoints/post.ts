import express from 'express'
import { add } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createCategorychema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createCategorychema), async (req, res)=>{
    console.log(req.body)
    
    const data = await add(req.body)
    res.json(data)
})

export default router;
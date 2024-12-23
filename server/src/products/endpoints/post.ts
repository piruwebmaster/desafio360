import express from 'express'
import { add } from '@products/service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createProductSchema } from '@products/schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createProductSchema), async (req, res)=>{
    console.log(req.body)
    
    const data = await add(req.body)
    res.json(data)
})

export default router;
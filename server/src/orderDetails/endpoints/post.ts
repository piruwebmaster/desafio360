import express from 'express'
import { add } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createSchema } from '../schemas';

const router = express.Router();

router.post('/', bodyValidatorMiddlware(createSchema), async (req, res)=>{
    
    const data = await add(req.body, req.user?.id ?? 0)
    res.json(data)
})

export default router;
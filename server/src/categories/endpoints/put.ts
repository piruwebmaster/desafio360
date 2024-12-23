import express from 'express'
import { update } from '../service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createCategorychema } from '../schemas';
import { updateDeleteResponseMiddleware } from '@middlewares/updateDeleteResponseMiddlware';

const router = express.Router();

router.put('/:id', bodyValidatorMiddlware(createCategorychema), updateDeleteResponseMiddleware, async (req, res)=>{
    const id = +req.params.id
    const body = req.body
    
    const data = await update({id,...body})
    res.json(data)
})

export default router;
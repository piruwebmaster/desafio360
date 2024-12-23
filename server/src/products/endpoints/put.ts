import express from 'express'
import { update } from '@products/service';
import { bodyValidatorMiddlware } from '@middlewares/bodyValidatorMiddleware';
import { createProductSchema } from '@products/schemas';
import { updateDeleteResponseMiddleware } from '@middlewares/updateDeleteResponseMiddlware';

const router = express.Router();

router.put('/:id', bodyValidatorMiddlware(createProductSchema), updateDeleteResponseMiddleware, async (req, res)=>{
    const id = +req.params.id
    const body = req.body
    
    const data = await update({id,...body})
    res.json(data)
})

export default router;
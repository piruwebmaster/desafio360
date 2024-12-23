import express from 'express'

import { removeById } from '../service';
import { updateDeleteResponseMiddleware } from '@middlewares/updateDeleteResponseMiddlware';

const router = express.Router();

router.delete('/:id', updateDeleteResponseMiddleware, async (req, res)=>{
    const id = +req.params.id
    const response =  await removeById(id)
    res.json(response);
})


export default router;
import 'dotenv/config'
import express from 'express'
import products from './products/routes'
import categories from './categories/routes'
import users from './users/routes'
import clients from './clients/routes'
import orders from './orders/routes'
import details from './orderDetails/routes'
import login from './login/routes'
import dotenv from 'dotenv';
import { validateToken } from '@middlewares/authMiddleware'
import { updateDeleteResponseMiddleware } from '@middlewares/updateDeleteResponseMiddlware'

const envFile = `.env.${process.env.NODE_ENV ?? 'development'}`;
dotenv.config({
    path: envFile
});
const app = express()

app.use(express.json());

const PORT = process.env.PORT
app.use('/api/v1', login)

app.use(validateToken)
app.use(updateDeleteResponseMiddleware)
app.use('/api/v1', products)
app.use('/api/v1', categories)
app.use('/api/v1', users)
app.use('/api/v1', clients)
app.use('/api/v1', orders)
app.use('/api/v1', details)


app.listen(PORT,()=>{
    console.log(`runnign on port ${PORT}`)
})
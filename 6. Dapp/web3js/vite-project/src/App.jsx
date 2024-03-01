import { useState } from 'react'


function App() {
  const [count, setCount] = useState(0)

  const Increment = () => {
    setCount(count + 1)
  }
  const Decrement = () => {
    setCount(count - 1)
  }

  return (
    <>
      {count}
      <button onClick={Increment}>J'aime</button>
      <button onClick={Decrement}>J'aime plus</button>
    </>
  )
}

export default App

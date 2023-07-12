'use client'

import React, { useState } from 'react'

const calculateWinner = squares => {
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ]

  for (let i = 0; i < lines.length; i += 1) {
    const [a, b, c] = lines[i]
    if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
      if (squares[a] === 'click') return null
      return squares[a]
    }
  }

  return squares.includes('click') ? null : 'draw'
}

function Square({ value, onClick }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="box-border w-20 h-20 border-2 border-gray-300 text-2xl"
    >
      {value}
    </button>
  )
}

function Board() {
  const [squares, setSquares] = useState(Array(9).fill('click'))
  const [xIsNext, setXIsNext] = useState(true)
  const winner = calculateWinner(squares)

  const handleClick = index => {
    if (squares[index] !== 'click') return
    squares[index] = xIsNext ? 'X' : 'O'
    setSquares(squares)
    setXIsNext(!xIsNext)
  }

  const resetGame = () => {
    setSquares(Array(9).fill('click'))
    setXIsNext(true)
  }

  const renderSquare = index => (
    <Square value={squares[index]} onClick={() => handleClick(index)} />
  )

  // eslint-disable-next-line no-nested-ternary
  const status = winner
    ? winner === 'draw'
      ? 'Game ended in a draw!'
      : `Player ${winner} won!`
    : `Next player: ${xIsNext ? 'X' : 'O'}`

  return (
    <div className="flex flex-col items-center">
      <div className="flex flex-wrap justify-center w-60 h-60">
        {Array(9)
          .fill(null)
          .map((_, i) => (
            // eslint-disable-next-line react/no-array-index-key
            <div key={i} className="text-blue-300">
              {renderSquare(i)}
            </div>
          ))}
      </div>
      <div className="mt-4 text-white text-2xl">{status}</div>
      {winner && (
        <button
          type="button"
          className="mt-4 p-2 bg-blue-500 text-white"
          onClick={resetGame}
        >
          Reset Game
        </button>
      )}
    </div>
  )
}

export default function Game() {
  return (
    <div className="flex justify-center py-6 bg-black">
      <Board />
    </div>
  )
}

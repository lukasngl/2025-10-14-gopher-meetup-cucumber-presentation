package cmd

import (
	"bufio"
	"io"
	"iter"
	"log/slog"
)

func Run(input io.Reader, output io.Writer, rot int) error {
	for line := range lines(input) {
		for i := range line {
			line[i] = rotN(rot, line[i])
		}
		_, err := output.Write(line)
		if err != nil {
			return err
		}
	}

	return nil
}

func lines(r io.Reader) iter.Seq[[]byte] {
	return func(yield func([]byte) bool) {
		br := bufio.NewReader(r)
		for {
			switch line, isPrefix, err := br.ReadLine(); {
			case err != nil:
				if err != io.EOF {
					slog.Warn("error reading line", "error", err)
				}

				return

			case isPrefix:
				slog.Warn("line too long, skipping")

			case !yield(line):
				return
			}
		}
	}
}

func rotN(n int, x byte) byte {
	rot := byte(n % 26)

	capital := x >= 'A' && x <= 'Z'
	if !capital && (x < 'a' || x > 'z') {
		return x // Not a letter
	}

	x += rot
	if capital && x > 'Z' || !capital && x > 'z' {
		x -= 26
	}

	return x
}

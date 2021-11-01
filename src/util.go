/*
 * Copyright (c) 2021 James Skarzinskas.
 * All rights reserved.
 * See LICENSE.txt in project root for license information.
 * Authors:
 *     James Skarzinskas <james@jskarzin.org>
 */
package main

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"strings"
	"unicode"
)

type CopyoverSession struct {
	Fd   int    `json:"fd"`
	Name string `json:"name"`
	Room int    `json:"room"`
}

type CopyoverData struct {
	Sessions []CopyoverSession `json:"sessions"`
}

func SimpleGET(url string, data string) (string, error) {
	resp, err := http.Get(url)
	if err != nil {
		return "", err
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(body), nil
}

func SimplePOST(url string, data string) (string, error) {
	resp, err := http.Post(url,
		"application/json",
		bytes.NewBuffer([]byte(data)))
	if err != nil {
		return "", err
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(body), nil
}

func oneArgument(args string) (string, string) {
	var buf strings.Builder
	var quoted bool = false
	var end int = len(args)

	for index, r := range args {
		if r == '\'' || r == '"' {
			if quoted {
				end = index
				break
			}

			quoted = true
		} else {
			if r != ' ' || quoted {
				buf.WriteRune(unicode.ToLower(r))
			} else if r == ' ' && !quoted {
				end = index
				break
			}
		}
	}

	if quoted && end+1 < len(args) {
		end++
	}

	return buf.String(), strings.TrimLeft(args[end:], " ")
}

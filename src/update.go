/*
 * Copyright (c) 2021 James Skarzinskas.
 * All rights reserved.
 * See LICENSE.txt in project root for license information.
 * Authors:
 *     James Skarzinskas <james@jskarzin.org>
 */
package main

import (
	"fmt"
	"time"
)

func (game *Game) characterUpdate() {
	for iter := game.Characters.Head; iter != nil; iter = iter.Next {
		ch := iter.Value.(*Character)

		if ch.Casting != nil {
			ch.onCastingUpdate()
		}
	}
}

func (game *Game) objectUpdate() {
	for iter := game.Objects.Head; iter != nil; iter = iter.Next {
		obj := iter.Value.(*ObjectInstance)

		/* Remove the obj after its ttl time in minutes, if the ITEM_DECAYS flag is set */
		if obj.Flags&ITEM_DECAYS != 0 && int(time.Since(obj.CreatedAt).Minutes()) >= obj.Ttl {
			if obj.Flags&ITEM_DECAY_SILENTLY == 0 {
				for innerIter := obj.InRoom.Characters.Head; innerIter != nil; innerIter = innerIter.Next {
					rch := innerIter.Value.(*Character)

					rch.Send(fmt.Sprintf("{D%s{D crumbles into dust.{x\r\n", obj.GetShortDescriptionUpper(rch)))
				}
			}

			/* If the object is a container, try to transfer all of its contents to the room */
			if obj.ItemType == ItemTypeContainer && obj.Contents != nil {
				for contentIter := obj.Contents.Head; contentIter != nil; contentIter = contentIter.Next {
					contentObj := contentIter.Value.(*ObjectInstance)

					obj.removeObject(contentObj)
					obj.InRoom.addObject(contentObj)
				}
			}

			obj.InRoom.removeObject(obj)
			game.Objects.Remove(obj)
		}
	}
}

func (game *Game) Update() {
	for iter := game.Characters.Head; iter != nil; iter = iter.Next {
		ch := iter.Value.(*Character)

		ch.onUpdate()
	}
}

func (game *Game) ZoneUpdate() {
	for iter := game.Zones.Head; iter != nil; iter = iter.Next {
		zone := iter.Value.(*Zone)

		if time.Since(zone.LastReset).Minutes() > float64(zone.ResetFrequency) {
			game.ResetZone(zone)
		}
	}
}

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
	"strings"
)

const (
	WearLocationNone    = 0
	WearLocationHead    = 1
	WearLocationNeck    = 2
	WearLocationArms    = 3
	WearLocationTorso   = 4
	WearLocationLegs    = 5
	WearLocationHands   = 6
	WearLocationShield  = 7
	WearLocationBody    = 8
	WearLocationWaist   = 9
	WearLocationWielded = 10
	WearLocationHeld    = 11
	WearLocationMax     = 12
)

var WearLocations = make(map[int]string)

func init() {
	/* Initialize our wear location string map */
	WearLocations[WearLocationNone] = ""
	WearLocations[WearLocationHead] = "<worn on head>        "
	WearLocations[WearLocationNeck] = "<worn around neck>    "
	WearLocations[WearLocationArms] = "<worn on arms>        "
	WearLocations[WearLocationTorso] = "<worn on torso>       "
	WearLocations[WearLocationLegs] = "<worn on legs>        "
	WearLocations[WearLocationHands] = "<worn on hands>       "
	WearLocations[WearLocationShield] = "<worn as shield>      "
	WearLocations[WearLocationBody] = "<worn on body>        "
	WearLocations[WearLocationWaist] = "<worn around waist>   "
	WearLocations[WearLocationWielded] = "<wielded>             "
	WearLocations[WearLocationHeld] = "<held>                "
}

func (ch *Character) examineObject(obj *ObjectInstance) {
	var output strings.Builder

	/*
	 * TODO: conditionally limit the amount of information revealed about the object
	 * based on factors like: perks/skills RE: lore knowledge, stats, luck, is admin, etc.
	 */
	output.WriteString(fmt.Sprintf("Object '%s' is type %s.\r\n", obj.name, obj.itemType))

	switch obj.itemType {
	case ItemTypeContainer:
		output.WriteString(fmt.Sprintf("can hold up to %d items with a maximum weight of %d lbs.", obj.value0, obj.value1))
	}

	if obj.contents.Count > 0 {
		output.WriteString(fmt.Sprintf("%s contains the following items:\r\n", obj.carriedBy.getShortDescriptionUpper(ch)))
		ch.showObjectList(obj.contents)
	}

	ch.Send(output.String())
}

func do_equipment(ch *Character, arguments string) {
	var output strings.Builder

	output.WriteString("\r\n{WYou are equipped with the following:{x\r\n")

	for i := WearLocationNone + 1; i < WearLocationMax; i++ {
		var objectDescription strings.Builder

		if ch.equipment[i] == nil {
			objectDescription.WriteString("nothing")
		} else {
			obj := ch.equipment[i]

			objectDescription.WriteString(obj.shortDescription)

			/* TODO: item flags - glowing, humming, etc? Append extra details here. */
		}

		output.WriteString(fmt.Sprintf("{C%s{x%s{x\r\n", WearLocations[i], objectDescription.String()))
	}

	ch.Send(output.String())
}

func do_inventory(ch *Character, arguments string) {
	var output strings.Builder
	var count int = 0
	var weightTotal float64 = 0.0

	output.WriteString("\r\n{YYour current inventory:{x\r\n")

	for iter := ch.inventory.Head; iter != nil; iter = iter.Next {
		obj := iter.Value.(*ObjectInstance)

		output.WriteString(fmt.Sprintf("{x    %s\r\n", obj.shortDescription))

		count++
	}

	output.WriteString(fmt.Sprintf("{xTotal: %d/%d items, %0.1f/%.1f lbs.\r\n",
		count,
		ch.getMaxItemsInventory(),
		weightTotal,
		ch.getMaxCarryWeight()))

	ch.Send(output.String())
}

func do_wear(ch *Character, arguments string) {
	if len(arguments) < 1 {
		ch.Send("Wear what?\r\n")
		return
	}

	ch.Send("Not yet implemented, try again soon!\r\n")
}

func do_remove(ch *Character, arguments string) {
	if len(arguments) < 1 {
		ch.Send("Remove what?\r\n")
		return
	}

	ch.Send("Not yet implemented, try again soon!\r\n")
}

func do_take(ch *Character, arguments string) {
	if len(arguments) < 1 {
		ch.Send("Take what?\r\n")
		return
	}

	if ch.Room == nil {
		return
	}

	var found *ObjectInstance = ch.findObjectInRoom(arguments)
	if found == nil {
		ch.Send("No such item found.\r\n")
		return
	}

	/* TODO: Check if object can be taken, weight limits, etc */

	ch.Room.removeObject(found)
	ch.addObject(found)

	ch.Send(fmt.Sprintf("You take %s{x.\r\n", found.shortDescription))
	outString := fmt.Sprintf("\r\n%s{x takes %s{x.\r\n", ch.name, found.shortDescription)

	if ch.Room != nil {
		for iter := ch.Room.characters.Head; iter != nil; iter = iter.Next {
			rch := iter.Value.(*Character)

			if rch != ch {
				rch.Send(outString)
			}
		}
	}
}

func do_drop(ch *Character, arguments string) {
	if len(arguments) < 1 {
		ch.Send("Drop what?\r\n")
		return
	}

	if ch.Room == nil {
		return
	}

	var found *ObjectInstance = ch.findObjectOnSelf(arguments)
	if found == nil {
		ch.Send("No such item in your inventory.\r\n")
		return
	}

	ch.removeObject(found)
	ch.Room.addObject(found)

	ch.Send(fmt.Sprintf("You drop %s{x.\r\n", found.shortDescription))
	outString := fmt.Sprintf("\r\n%s drops %s{x.\r\n", ch.name, found.shortDescription)

	if ch.Room != nil {
		for iter := ch.Room.characters.Head; iter != nil; iter = iter.Next {
			rch := iter.Value.(*Character)

			if rch != ch {
				rch.Send(outString)
			}
		}
	}
}

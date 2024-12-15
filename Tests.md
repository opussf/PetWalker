# Tests

## Login event
| events               | V0       | V      | VV     | VVV        |
| :--:                 | :--      | :--    | :--    | :--        |
| Login[^1]            | No msg   | No msg | No msg | No msg     |
| SetPetLodOutInfo[^2] | No msg   | No msg | No msg | msg[^msg1] |
| Player_Moves         | No msg   | No msg | No msg | msg[^msg2] |


## After Battle
| events               | V0       | V      | VV     | VVV    |
| :--:                 | :--      | :--    | :--    | :--    |
| Login[^1]            | No msg   | No msg | No msg | No msg |
| SetPetLodOutInfo[^2] | No msg   | No msg | No msg | No msg |
| Player_Moves         | No msg   |



[^1]: ns.pet_verified is set to false
[^2]: Pet loadout changed in Pet Journal

[^msg1]: PetWalker: Summoned pet not saved.
[^msg2]: PetWalker: Summoned your last save pet [petname]



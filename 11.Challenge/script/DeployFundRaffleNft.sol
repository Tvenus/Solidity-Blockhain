// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Script } from "forge-std/Script.sol";

import { FundRaffleMoodNft } from "../src/FundRaffleNft.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { console } from "forge-std/console.sol";

contract DeployMoodNft is Script {
	uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
		0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
	uint256 public deployerKey;

	function run() external returns (FundRaffleMoodNft) {
		if (block.chainid == 31337) {
			deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
		} else {
			deployerKey = vm.envUint("PRIVATE_KEY");
		}

		string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
		string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");

		vm.startBroadcast(deployerKey);

		FundRaffleMoodNft moodNft = new FundRaffleMoodNft(
			svgToImageURI(sadSvg),
			svgToImageURI(happySvg)
		);
		vm.stopBroadcast();
		return moodNft;
	}

	// You could also just upload the raw SVG and have solildity convert it!
	function svgToImageURI(
		string memory svg
	) public pure returns (string memory) {
		// example:
		// '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
		// would return ""
		string memory baseURL = "data:image/svg+xml;base64,";
		string memory svgBase64Encoded = Base64.encode(
			bytes(string(abi.encodePacked(svg)))
		);
		return string(abi.encodePacked(baseURL, svgBase64Encoded));
	}
}

import { 
  Account, 
  Chain, 
  Tx 
} from '../utils/helpers.ts';
import { PROPOSALS } from '../utils/contract-addresses.ts';

export enum SDE_MEMBERSHIP_CODES {
  ERR_UNAUTHORIZED = 2900,
  ERR_NOT_A_MEMBER = 2901,
}

export class SDEMembership {
  chain: Chain;

  constructor(chain: Chain) {
    this.chain = chain;
  };

  setMember(sender: Account, who: string, isMember: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall('sde-membership', 'set-member', [who, isMember], sender.address),
    ]);

    return { result: block.receipts[0].result, events: block.receipts[0].events };
  };

  setBlacklist(sender: Account, who: string, isMember: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall('sde-membership', 'set-blacklist', [who, isMember], sender.address),
    ]);

    return { result: block.receipts[0].result, events: block.receipts[0].events };
  };

  isMember(sender: Account, who: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall('sde-membership', 'is-member', [who], sender.address),
    ]);

    return { result: block.receipts[0].result, events: block.receipts[0].events };
  };

  isBlacklisted(sender: Account, who: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall('sde-membership', 'is-blacklisted', [who], sender.address),
    ]);

    return { result: block.receipts[0].result, events: block.receipts[0].events };
  };

  callback(sender: Account, memo: string) {
    let block = this.chain.mineBlock([
      Tx.contractCall('sde-membership', 'callback', [memo], sender.address),
    ]);

    return { result: block.receipts[0].result, events: block.receipts[0].events };
  };
};
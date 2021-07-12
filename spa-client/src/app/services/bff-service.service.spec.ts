import { TestBed } from '@angular/core/testing';

import { BffServiceService } from './bff-service.service';

describe('BffServiceService', () => {
  let service: BffServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BffServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

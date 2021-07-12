import { Component, OnInit } from '@angular/core';
import { Router }  from '@angular/router';
import { take } from 'rxjs/operators';
import { ApplicationInsights } from '@microsoft/applicationinsights-web';
import { AngularPlugin } from '@microsoft/applicationinsights-angularplugin-js';
import { ClickAnalyticsPlugin } from '@microsoft/applicationinsights-clickanalytics-js';
import { environment } from 'src/environments/environment';
import { BffServiceService } from './services/bff-service.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Tour of Heroes';
  constructor(private router: Router, private bffService: BffServiceService) { }

  ngOnInit() {
    if (environment.production) {
      const angularPlugin = new AngularPlugin();
      const clickPlugin = new ClickAnalyticsPlugin();      
      const appInsights = new ApplicationInsights({
        config: {
          instrumentationKey: environment.instrumentationKey,
          enableCorsCorrelation: true,
          enableRequestHeaderTracking: true,
          enableResponseHeaderTracking: true,
          extensions: [ angularPlugin, clickPlugin ],
          extensionConfig: {
            [angularPlugin.identifier]: {
              router: this.router
            },
            [clickPlugin.identifier]: {
              autoCapture: true
            }
          }
        }
      });
      appInsights.loadAppInsights();
      appInsights.addTelemetryInitializer(envelope => {
        if (envelope && envelope.tags) {
          envelope.tags['ai.cloud.role'] = 'spa-client';
        }
      });
      console.log('app insights is loaded');
    } else {
      console.log('app insights is not loaded');
    }
    setTimeout(() => this.contactWebService());
  }

  contactWebService() {
    this.bffService.getBff().pipe(take(1)).subscribe(
      success => {
        console.log(success);
      },
      error => {
        console.log(error);
      }
    );
  }
}

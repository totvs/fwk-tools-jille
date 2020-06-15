import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { IdiomaDetailComponent } from './idioma/detail/idioma-detail.component';
import { IdiomaEditComponent } from './idioma/edit/idioma-edit.component';
import { IdiomaListComponent } from './idioma/list/idioma-list.component';

const routes: Routes = [
  { path: 'idiomas/create', component: IdiomaEditComponent },
  { path: 'idiomas/edit/:id', component: IdiomaEditComponent },
  { path: 'idiomas/detail/:id', component: IdiomaDetailComponent },
  { path: 'idiomas', component: IdiomaListComponent },
  { path: '', redirectTo: '/idiomas', pathMatch: 'full' },
  { path: '**', component: IdiomaListComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

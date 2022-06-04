/***************************************************************************
 *   Copyright (C) 2018 David Edmundson <davidedmundson@kde.org>                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

.pragma library

//written as a library to share knowledge of when a key was pressed
//between the multiple views, so pressing a key on one cancels all timers

var callbacks = [];

function addCancelAutoTriggerCallback(callback) {
    callbacks.push(callback);
}

function cancelAutoTrigger() {
    callbacks.forEach(function(c) {
        if (!c) {
            return;
        }
        c();
    });
}

